using eCinema.Core;
using eCinema.Core.Dtos.Movie;

namespace eCinema.Application
{
    public class MovieProfile : BaseProfile
    {
        public MovieProfile()
        {
            CreateMap<MovieDto, Movie>().ReverseMap();

            CreateMap<MovieUpsertDto, Movie>();

            CreateMap<MovieUpsertDto, MovieUpsertModel>().ReverseMap();
        }
    }
}
