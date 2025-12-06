using eCinema.Core;

namespace eCinema.Application
{
    public class MovieReactionProfile : BaseProfile
    {
        public MovieReactionProfile()
        {
            CreateMap<MovieReactionDto, MovieReaction>().ReverseMap();

            CreateMap<MovieReactionUpsertDto, MovieReaction>();
        }
    }
}
