using eCinema.Core;
using FluentValidation;

namespace eCinema.Application
{
    public class UserValidator : AbstractValidator<UserUpsertDto>
    {
        public UserValidator()
        {
            RuleFor(c => c.FirstName).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
            RuleFor(c => c.LastName).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
            RuleFor(c => c.Email).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
            RuleFor(c => c.PhoneNumber).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);

            RuleFor(c => c.Password)
                .NotNull()
                .NotEmpty()
                .MinimumLength(8)
                .Matches(@"[A-Z]+")
                .Matches(@"[a-z]+")
                .Matches(@"[0-9]+")
                .WithErrorCode(ErrorCodes.InvalidValue)
                .When(u => u.Id == null || u.Password != null);

            RuleFor(c => c.Gender).IsInEnum().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.BirthDate).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.IsActive).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.IsVerified).NotNull().WithErrorCode(ErrorCodes.NotNull);

        //    RuleFor(u => u.ProfilePhoto)
        //      .MustAsync(async (profilePhoto, cancellationToken) => await ValidatePhotoSizeAsync(profilePhoto, cancellationToken))
        //      .WithErrorCode(ErrorCodes.InvalidSize).When(u => u.ProfilePhoto != null)
        //      .MustAsync(async (profilePhoto, cancellationToken) => await ValidatePhotoTypeAsync(profilePhoto.ContentType, cancellationToken))
        //      .WithErrorCode(ErrorCodes.InvalidType).When(u => u.ProfilePhoto != null);
        }

        //protected async Task<bool> ValidatePhotoSizeAsync(PhotoUpsertDto profilePhoto, CancellationToken cancellationToken = default)
        //{
        //    var fileSize = profilePhoto.Data.Length;
        //    if (fileSize <= 3145728)
        //        return true;
        //    else
        //        return false;
        //}

        //protected async Task<bool> ValidatePhotoTypeAsync(string contentType, CancellationToken cancellationToken = default)
        //{
        //    var validExtensions = new string[] { "image/jpeg", "image/jpg", "image/png", "image/gif" };
        //    return validExtensions.Contains(contentType);
        //}
    }
}
