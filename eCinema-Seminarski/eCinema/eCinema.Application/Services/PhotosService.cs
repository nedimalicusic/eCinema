using AutoMapper;
using FluentValidation;

using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure;
using eCinema.Infrastructure.Interfaces;
using SixLabors.ImageSharp.Formats.Jpeg;
using SixLabors.ImageSharp.Processing;
using SixLabors.ImageSharp;
using eCinema.Core.Dtos.Photo;

namespace eCinema.Application
{
    public class PhotosService : BaseService<Photo, PhotoDto, PhotoUpsertDto, BaseSearchObject, IPhotosRepository>, IPhotosService
    {
        private const int ThumbnailWidth = 155;

        public PhotosService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<PhotoUpsertDto> validator) : base(mapper, unitOfWork, validator)
        {
        }
        public async Task<List<Guid>> ProcessAsync(IEnumerable<PhotoUpsertModel> images)
        {
            var imageIds = new List<Guid>();

            foreach (var image in images)
            {
                using var imageResult = await SixLabors.ImageSharp.Image.LoadAsync(image.Content);

                var original = await SaveImageAsync(imageResult, imageResult.Width);
                var thumbnail = await SaveImageAsync(imageResult, ThumbnailWidth);

                var photo = new Photo
                {
                    ContentType = image.Type,
                    Data = original,
                    ThumbnailContent = thumbnail
                };

                await CurrentRepository.AddAsync(photo);
                await UnitOfWork.SaveChangesAsync();

                imageIds.Add(photo.GuidId);


            }

            return imageIds;
        }

        private async Task<byte[]> SaveImageAsync(SixLabors.ImageSharp.Image image, int resizeWidth)
        {
            var width = image.Width;
            var height = image.Height;

            if (width > resizeWidth)
            {
                height = (int)((double)resizeWidth / width * height);
                width = resizeWidth;
            }

            image.Mutate(x => x.Resize(width, height));
            image.Metadata.ExifProfile = null;

            var memoryStream = new MemoryStream();

            await image.SaveAsJpegAsync(memoryStream, new JpegEncoder
            {
                Quality = 80
            });

            return memoryStream.ToArray();
        }


        public async Task<byte[]?> GetImageAsync(Guid id, bool original)
        {
            if (original)
            {
                return await CurrentRepository.GetOriginalContet(id);
            }

            return await CurrentRepository.GetThumbnailContent(id);
        }

        public async Task<int> GetPhotoIdByGuidId(Guid guidId, CancellationToken cancellationToken = default)
        {
            return await CurrentRepository.GetPhotoIdByGuidId(guidId, cancellationToken);
        }
    }
}
